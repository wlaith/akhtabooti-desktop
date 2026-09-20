import { ref } from "vue";
import { i18n } from "../i18n";

type Locale = "en" | "ar";

const STORAGE_KEY = "locale";
const RTL_LOCALES: Locale[] = ["ar"];

const locale = ref<Locale>("en");

function apply(next: Locale) {
  locale.value = next;
  i18n.global.locale.value = next;
  document.documentElement.lang = next;
  document.documentElement.dir = RTL_LOCALES.includes(next) ? "rtl" : "ltr";
}

function init() {
  const stored = localStorage.getItem(STORAGE_KEY) as Locale | null;
  if (stored === "en" || stored === "ar") {
    apply(stored);
    return;
  }
  apply(navigator.language.toLowerCase().startsWith("ar") ? "ar" : "en");
}

function setLocale(next: Locale) {
  localStorage.setItem(STORAGE_KEY, next);
  apply(next);
}

function toggle() {
  setLocale(locale.value === "ar" ? "en" : "ar");
}

export function useLocale() {
  return { locale, init, toggle, setLocale };
}
