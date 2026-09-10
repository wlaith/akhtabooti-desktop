<script setup lang="ts">
import { ref } from "vue";
import Icon from "../icon/Icon.vue";

withDefaults(defineProps<{ title: string; disabled?: boolean }>(), {
  disabled: false,
});

const open = ref(false);
</script>

<template>
  <div class="border-t border-[#c6c6c6]">
    <button
      type="button"
      :disabled="disabled"
      class="flex w-full items-center gap-4 px-4 py-[14px] text-left outline-none disabled:cursor-not-allowed"
      :class="disabled ? 'text-[rgba(22,22,22,0.25)]' : 'text-[#161616] hover:bg-[#e8e8e8]'"
      :aria-expanded="open"
      @click="open = !open"
    >
      <span class="min-w-0 flex-1 text-[14px] leading-[20px] tracking-[0.16px]">{{ title }}</span>
      <Icon :name="open ? 'chevron-up' : 'chevron-down'" />
    </button>
    <div
      v-if="open && !disabled"
      class="flex flex-col gap-4 pt-2 pr-12 pb-6 pl-4 text-[14px] leading-[20px] tracking-[0.16px] text-[#161616]"
    >
      <slot />
    </div>
  </div>
</template>
