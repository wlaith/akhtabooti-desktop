<script setup lang="ts">
import { useI18n } from "vue-i18n";

withDefaults(defineProps<{ size?: number }>(), { size: 16 });
const { t } = useI18n();
</script>

<template>
  <span
    class="inline-block shrink-0 animate-spin rounded-full border-2 border-text-primary/20 border-t-action-primary"
    :style="{ width: `${size}px`, height: `${size}px` }"
    role="status"
    :aria-label="t('spinner.scanning')"
  />
</template>
