<script setup lang="ts">
import Tooltip from "../tooltip/Tooltip.vue";
import Icon from "../icon/Icon.vue";

defineProps<{ count: number }>();
defineEmits<{
  (e: "export"): void;
  (e: "cancel"): void;
}>();
</script>

<template>
  <div
    class="sticky top-0 z-10 flex flex-wrap items-center gap-y-1 bg-action-primary text-text-inverse"
  >
    <span class="flex-1 px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px]">
      {{ count }} selected
    </span>
    <div class="flex flex-wrap items-center">
      <Tooltip wrap text="Download the selected files' findings as a report">
        <button
          type="button"
          class="flex cursor-pointer items-center gap-1 px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px] hover:bg-text-inverse/10"
          @click="$emit('export')"
        >
          Export
          <Icon name="information" :size="12" />
        </button>
      </Tooltip>
      <span class="mx-2 h-5 w-px bg-text-inverse/40" />
      <button
        type="button"
        class="cursor-pointer px-4 py-[15px] text-[14px] leading-[18px] tracking-[0.16px] hover:bg-text-inverse/10"
        @click="$emit('cancel')"
      >
        Cancel
      </button>
    </div>
  </div>
</template>
