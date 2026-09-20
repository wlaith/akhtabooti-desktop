import { createApp } from "vue";
import App from "./App.vue";
import { i18n } from "./i18n";
import { useTheme } from "./composables/useTheme";
import { useLocale } from "./composables/useLocale";
import "./style.css";

useTheme().init();
useLocale().init();
createApp(App).use(i18n).mount("#app");
