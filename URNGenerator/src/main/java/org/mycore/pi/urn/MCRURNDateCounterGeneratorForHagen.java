package org.mycore.pi.urn;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.TimeZone;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Predicate;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.mycore.pi.MCRPIRegistrationInfo;
import org.mycore.pi.MCRPersistentIdentifierGenerator;
import org.mycore.pi.MCRPersistentIdentifierManager;
import org.mycore.pi.exceptions.MCRPersistentIdentifierException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Builds a new, unique NISS based on the current date and/or time
 * in combination with a counter. The date/time can be formatted with
 * a Java SimpleDateFormat pattern, the counter can be formatted with
 * a Java DecimalFormat pattern. The property "NISSPattern" is used
 * for configuring the instance. Example configuration:
 *
 * MCR.URN.SubNamespace.Essen.Prefix=urn:nbn:de:465-miless-
 * MCR.URN.SubNamespace.Essen.NISSBuilder=org.mycore.urn.services.MCRNISSBuilderDateCounter
 * MCR.URN.SubNamespace.Essen.NISSPattern=yyyyMMdd-HHmmss-000
 *
 * Subsequent calls to MCRURN.buildURN( "Essen" ) could then generate
 * the following URNs, for example:
 *
 * urn:nbn:de:465-miless-20060622-213404-0017
 * urn:nbn:de:465-miless-20060622-213404-0025
 * urn:nbn:de:465-miless-20060622-213448-0013
 *
 * The last character is the checksum digit.
 * In the first two URNs, the generated date pattern is the same, so
 * the counter is increased (starting at 1). The use of "0" instead of
 * "#" in the pattern produces leading zeros.
 *
 * A pattern might have no date part (only use counter)
 * or no counter part (only use date pattern)
 *
 * @author Frank Lützenkirchen
 * 
 * 2018-05-28 edited by Paul Borchert get counter by DB
 */
public class MCRURNDateCounterGeneratorForHagen extends MCRDNBURNGenerator {

    private DecimalFormat fmtCount;

    private SimpleDateFormat fmtDate;

    private String lastDate;

    private int counter = 1;
    
    private static final Map<String, AtomicInteger> PATTERN_COUNT_MAP = new HashMap<>();
    
    private static final Logger LOGGER = LogManager.getLogger();

    public MCRURNDateCounterGeneratorForHagen(String generatorID) {
        super(generatorID);

        String pattern = getProperties().get("Pattern");
        String patternDate = pattern;
        String patternCounter = "";

        int pos1 = pattern.indexOf("0");
        int pos2 = pattern.indexOf("#");
        if (pos1 >= 0 || pos2 >= 0) {
            int pos;

            if (pos1 == -1) {
                pos = pos2;
            } else if (pos2 == -1) {
                pos = pos1;
            } else {
                pos = Math.min(pos1, pos2);
            }

            patternDate = pattern.substring(0, pos);
            patternCounter = pattern.substring(pos);
        }

        if (patternDate.length() > 0) {
            fmtDate = new SimpleDateFormat(patternDate, Locale.GERMAN);
        }

        if (patternCounter.length() > 0) {
            fmtCount = new DecimalFormat(patternCounter, DecimalFormatSymbols.getInstance(Locale.GERMAN));
        }
        
        String Pattern = "urn:nbn:de:" + getProperties().get("Namespace")+"([0-9]+)[0-9]";
        counter=getCount(Pattern);
        LOGGER.info("[MCRURNDateCounterGeneratorForHagen] initCounter via getCounter: " + counter + " (pattern:"+ Pattern + ")");
    }

    @Override
    protected String buildNISS() {
        String niss;

        StringBuilder sb = new StringBuilder();

        if (fmtDate != null) {
            Calendar now = new GregorianCalendar(TimeZone.getTimeZone("GMT-1:00"), Locale.GERMAN);
            String date = fmtDate.format(now.getTime());
            sb.append(date);

            if (!date.equals(lastDate)) {
                lastDate = date;
                counter = 1; // reset counter, new date
            }
        }
        
        if (fmtCount != null) {
            sb.append(fmtCount.format(counter++));
        }

        niss = sb.toString();

        return niss;
    }
    
    
    public final synchronized int getCount(String pattern) {
        AtomicInteger count = PATTERN_COUNT_MAP.computeIfAbsent(pattern, (pattern_) -> {
            Pattern regExpPattern = Pattern.compile(pattern_);
            Predicate<String> matching = regExpPattern.asPredicate();

            List<MCRPIRegistrationInfo> list = MCRPersistentIdentifierManager.getInstance()
                .getList(MCRDNBURN.TYPE, -1, -1);

            Comparator<Integer> integerComparator = Integer::compareTo;
            Optional<Integer> highestNumber = list.stream()
                .map(MCRPIRegistrationInfo::getIdentifier)
                .filter(matching)
                .map(pi -> {
                    // extract the number of the PI
                    Matcher matcher = regExpPattern.matcher(pi);
                    if (matcher.find() && matcher.groupCount() == 1) {
                        String group = matcher.group(1);
                        return Integer.parseInt(group, 10);
                    } else {
                        return null;
                    }
                }).filter(Objects::nonNull)
                .sorted(integerComparator.reversed())
                .findFirst()
                .map(n -> n + 1);
            return new AtomicInteger(highestNumber.orElse(0));
        });

        return count.getAndIncrement();
    }

}
