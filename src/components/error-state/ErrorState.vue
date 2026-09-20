<script setup lang="ts">
import { useI18n } from "vue-i18n";
import Icon from "../icon/Icon.vue";
import Button from "../button/Button.vue";

defineProps<{ detail?: string }>();
const emit = defineEmits<{ (e: "retry"): void }>();
const { t } = useI18n();
</script>

<template>
  <section role="alert" class="flex w-full flex-col items-center gap-4 py-24 text-center">
    <Icon name="subtract-alt" :size="48" class="text-error" />
    <div class="max-w-md">
      <h2 class="text-[20px] font-semibold text-text-primary">{{ t("errorState.title") }}</h2>
      <p class="mt-2 text-[14px] text-text-secondary">
        {{ t("errorState.description") }}
      </p>
      <p v-if="detail" class="mt-2 text-[12px] break-all text-text-tertiary">{{ detail }}</p>
    </div>
    <Button size="medium" @click="emit('retry')">{{ t("errorState.tryAgain") }}</Button>
  </section>
</template>
