<script setup lang="ts">
import { useI18n } from "vue-i18n";
import SidebarItem from "./SidebarItem.vue";
import Tooltip from "../tooltip/Tooltip.vue";
import { useTheme } from "../../composables/useTheme";
import { useLocale } from "../../composables/useLocale";

defineProps<{ active: "scan" | "guide" }>();
defineEmits<{ (e: "select", view: "scan" | "guide" | "about"): void }>();

const { t } = useI18n();
const { isDark, toggle } = useTheme();
const { locale, toggle: toggleLocale } = useLocale();
</script>

<template>
  <nav
    class="flex h-full w-13 shrink-0 flex-col items-center border-e border-text-primary/12 bg-surface py-2"
    :aria-label="t('sidebar.primaryNav')"
  >
    <img src="/logo.png" alt="Akhtabooti" class="mb-2 h-6 w-6 shrink-0 object-contain" />
    <div class="mb-2 h-px w-8 shrink-0 bg-text-primary/12" aria-hidden="true" />

    <SidebarItem
      icon="scan-analyze"
      :label="t('sidebar.scan')"
      :active="active === 'scan'"
      @click="$emit('select', 'scan')"
    />

    <div class="mt-auto flex flex-col items-center gap-1">
      <Tooltip :text="locale === 'ar' ? t('sidebar.switchToEnglish') : t('sidebar.switchToArabic')" placement="right" wrap>
        <button
          type="button"
          class="flex h-10 w-10 items-center justify-center text-[12px] font-semibold text-text-primary outline-none hover:bg-text-primary/8"
          :aria-label="locale === 'ar' ? t('sidebar.switchToEnglish') : t('sidebar.switchToArabic')"
          @click="toggleLocale"
        >
          {{ locale === "ar" ? "EN" : "AR" }}
        </button>
      </Tooltip>
      <SidebarItem
        :icon="isDark ? 'sun' : 'moon'"
        :label="isDark ? t('sidebar.switchToLightMode') : t('sidebar.switchToDarkMode')"
        @click="toggle"
      />
      <SidebarItem
        icon="help"
        :label="t('sidebar.guide')"
        :active="active === 'guide'"
        @click="$emit('select', 'guide')"
      />
      <SidebarItem icon="information" :label="t('sidebar.about')" @click="$emit('select', 'about')" />
    </div>
  </nav>
</template>
