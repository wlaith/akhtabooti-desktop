<script setup lang="ts">
import { ref } from "vue";

withDefaults(defineProps<{ text: string; wrap?: boolean; placement?: "top" | "right" }>(), {
  wrap: false,
  placement: "top",
});
const open = ref(false);
</script>

<template>
  <span
    class="relative inline-flex"
    @mouseenter="open = true"
    @mouseleave="open = false"
    @focusin="open = true"
    @focusout="open = false"
  >
    <!-- wrap: tooltip sits over an already-interactive child (button, checkbox label),
         so it must not add its own button/click handling on top of it -->
    <slot v-if="wrap" />
    <button
      v-else
      type="button"
      class="flex cursor-pointer items-center text-text-secondary outline-none hover:text-text-primary"
      :aria-expanded="open"
      aria-label="More information"
      @click="open = !open"
    >
      <slot />
    </button>
    <span
      v-if="open"
      role="tooltip"
      class="absolute z-20 w-max max-w-[288px] text-left text-[12px] leading-[16px] text-text-inverse bg-text-primary rounded px-3 py-2 shadow-lg"
      :class="
        placement === 'right'
          ? 'top-1/2 left-full ml-2 -translate-y-1/2'
          : 'bottom-full left-1/2 mb-2 -translate-x-1/2'
      "
    >
      {{ text }}
    </span>
  </span>
</template>
