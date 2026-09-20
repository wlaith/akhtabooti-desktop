<script setup lang="ts">
import { computed } from "vue";
import { useI18n } from "vue-i18n";
import Icon from "../icon/Icon.vue";

defineEmits<{ (e: "close"): void }>();

const { t, tm } = useI18n();
const sections = computed(() => tm("guideView.sections") as { title: string; body: string }[]);
</script>

<template>
  <section class="flex h-full flex-col overflow-y-auto p-8">
    <div class="mb-6 flex items-start justify-between">
      <h2 class="text-[24px] leading-[32px] font-semibold text-text-primary">{{ t("guideView.title") }}</h2>
      <button
        type="button"
        class="flex h-8 w-8 items-center justify-center text-text-secondary outline-none hover:bg-text-primary/8 hover:text-text-primary"
        :aria-label="t('guideView.close')"
        @click="$emit('close')"
      >
        <Icon name="close" :size="16" />
      </button>
    </div>

    <div class="flex max-w-[640px] flex-col gap-6">
      <div v-for="section in sections" :key="section.title">
        <h3 class="mb-1 text-[16px] font-semibold text-text-primary">{{ section.title }}</h3>
        <p class="text-[14px] leading-[20px] text-text-secondary">{{ section.body }}</p>
      </div>
    </div>
  </section>
</template>
