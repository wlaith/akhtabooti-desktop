import { createI18n } from "vue-i18n";
import en from "./locales/en.json";
import ar from "./locales/ar.json";

// CLDR Arabic plural categories: zero, one, two, few (3-10), many (11-99), other.
// Message strings for `ar` must provide exactly these 6 pipe-separated forms, in this order.
function arabicPluralRule(choice: number, choicesLength: number): number {
  const index = (() => {
    if (choice === 0) return 0;
    if (choice === 1) return 1;
    if (choice === 2) return 2;
    const mod100 = choice % 100;
    if (mod100 >= 3 && mod100 <= 10) return 3;
    if (mod100 >= 11 && mod100 <= 99) return 4;
    return 5;
  })();
  return Math.min(index, choicesLength - 1);
}

export const i18n = createI18n({
  legacy: false,
  locale: "en",
  fallbackLocale: "en",
  messages: { en, ar },
  pluralRules: { ar: arabicPluralRule },
});
