import { ref } from "vue";

type Theme = "light" | "dark";

const STORAGE_KEY = "theme";

const isDark = ref(false);
let media: MediaQueryList | null = null;

function apply(dark: boolean) {
  isDark.value = dark;
  document.documentElement.classList.toggle("dark", dark);
}

function followSystem() {
  apply(media?.matches ?? false);
}

function init() {
  media = window.matchMedia("(prefers-color-scheme: dark)");
  const stored = localStorage.getItem(STORAGE_KEY) as Theme | null;

  if (stored === "light" || stored === "dark") {
    apply(stored === "dark");
  } else {
    followSystem();
    media.addEventListener("change", followSystem);
  }
}

function toggle() {
  media?.removeEventListener("change", followSystem);
  const next: Theme = isDark.value ? "light" : "dark";
  localStorage.setItem(STORAGE_KEY, next);
  apply(next === "dark");
}

export function useTheme() {
  return { isDark, init, toggle };
}
