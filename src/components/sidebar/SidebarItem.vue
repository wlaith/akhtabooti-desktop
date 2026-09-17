<script setup lang="ts">
import Icon from "../icon/Icon.vue";
import Tooltip from "../tooltip/Tooltip.vue";

defineProps<{
  icon: "scan-analyze" | "help" | "information" | "sun" | "moon";
  label: string;
  active?: boolean;
}>();
defineEmits<{ (e: "click"): void }>();
</script>

<template>
  <Tooltip :text="label" placement="right" wrap>
    <button
      type="button"
      class="relative flex h-10 w-10 items-center justify-center text-text-primary outline-none hover:bg-text-primary/8"
      :class="active ? 'bg-text-primary/8' : ''"
      :aria-label="label"
      :aria-current="active ? 'page' : undefined"
      @click="$emit('click')"
    >
      <span
        v-if="active"
        class="absolute top-1 bottom-1 left-0 w-[3px] bg-action-primary"
        aria-hidden="true"
      />
      <Icon :name="icon" :size="20" />
    </button>
  </Tooltip>
</template>
