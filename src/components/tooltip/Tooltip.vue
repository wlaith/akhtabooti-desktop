<script setup lang="ts">
import { ref } from "vue";

withDefaults(defineProps<{ text: string; wrap?: boolean }>(), { wrap: false });
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
      class="flex cursor-pointer items-center text-[#525252] outline-none hover:text-[#161616]"
      :aria-expanded="open"
      aria-label="More information"
      @click="open = !open"
    >
      <slot />
    </button>
    <span
      v-if="open"
      role="tooltip"
      class="absolute bottom-full left-1/2 z-20 mb-2 w-max max-w-[288px] -translate-x-1/2 rounded bg-[#393939] px-3 py-2 text-left text-[12px] leading-[16px] text-white shadow-lg"
    >
      {{ text }}
    </span>
  </span>
</template>
