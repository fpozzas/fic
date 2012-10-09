function addTag(e, tag) {
    e.focus();
    e.value = ((e.value.length > 0) ? e.value + ", " : "") + tag;
}