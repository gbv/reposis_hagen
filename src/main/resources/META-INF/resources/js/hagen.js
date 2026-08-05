function replaceMaskedEmails() {
  document.querySelectorAll('span.madress').forEach(span => {
    const address = span.textContent.replace(' [at] ', '@');
    const link = document.createElement('a');
    link.href = `mailto:${address}`;
    link.textContent = address;
    span.replaceWith(link);
  });
}

function init() {
  replaceMaskedEmails();
}

document.addEventListener("DOMContentLoaded", init);
