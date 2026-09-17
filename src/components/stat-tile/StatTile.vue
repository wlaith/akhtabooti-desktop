<script setup lang="ts">
import { useI18n } from "vue-i18n";
import Button from "../button/Button.vue";
import Icon from "../icon/Icon.vue";

withDefaults(
  defineProps<{ label: string; value: number | string; clickable?: boolean; active?: boolean }>(),
  {
    clickable: false,
    active: false,
  },
);
defineEmits<{ (e: "click"): void }>();

const { t } = useI18n();
</script>

<template>
  <div
    class="flex min-w-[180px] flex-1 flex-col gap-3 border bg-surface p-4"
    :class="active ? 'border-action-primary' : 'border-text-primary/12'"
  >
    <div>
      <span class="text-[28px] leading-[36px] font-normal text-text-primary">{{ value }}</span>
      <span class="block text-[14px] leading-[18px] tracking-[0.16px] text-text-primary">{{
        label
      }}</span>
    </div>
    <Button v-if="clickable" :variant="active ? 'primary' : 'outline'" size="small" class="self-start" @click="$emit('click')">
      {{ active ? t("statTile.removeFilter") : t("statTile.applyFilter") }}
      <template #icon><Icon :name="active ? 'filter-remove' : 'filter'" :size="14" /></template>
    </Button>
  </div>
</template>
