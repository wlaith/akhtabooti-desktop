<script setup lang="ts">
import { useI18n } from "vue-i18n";
import Icon from "../icon/Icon.vue";

defineEmits<{ (e: "close"): void }>();
const { t } = useI18n();
</script>

<template>
  <div class="fixed inset-0 z-30 flex items-center justify-center bg-black/40" @click.self="$emit('close')">
    <div
      class="w-full max-w-[400px] bg-surface p-6 shadow-xl"
      role="dialog"
      aria-modal="true"
      aria-labelledby="about-title"
    >
      <div class="mb-4 flex items-start justify-between">
        <div class="flex items-center gap-3">
          <img src="/logo.png" alt="" class="h-8 w-8 object-contain" />
          <div>
            <h2 id="about-title" class="text-[18px] font-semibold text-text-primary">{{ t("aboutDialog.title") }}</h2>
            <p class="text-[13px] text-text-secondary">{{ t("aboutDialog.version") }}</p>
          </div>
        </div>
        <button
          type="button"
          class="text-text-secondary outline-none hover:text-text-primary"
          :aria-label="t('aboutDialog.close')"
          @click="$emit('close')"
        >
          <Icon name="close" :size="16" />
        </button>
      </div>

      <p class="mb-4 text-[14px] leading-[20px] text-text-primary">
        {{ t("aboutDialog.description") }}
      </p>

      <p class="mb-4 flex items-start gap-2 rounded bg-neutral-bg p-3 text-[13px] leading-[18px] text-text-primary">
        {{ t("aboutDialog.privacy") }}
      </p>

      <p class="text-[12px] text-text-secondary">
        {{ t("aboutDialog.licence") }} <a href="#" class="text-action-primary underline">{{ t("aboutDialog.reportIssue") }}</a>
      </p>
    </div>
  </div>
</template>
