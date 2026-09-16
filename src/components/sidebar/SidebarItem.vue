<script setup lang="ts">
import Icon from "../icon/Icon.vue";
import Tooltip from "../tooltip/Tooltip.vue";

defineProps<{
  icon: "scan-analyze" | "help" | "information";
  label: string;
  active?: boolean;
}>();
defineEmits<{ (e: "click"): void }>();
</script>

<template>
  <Tooltip :text="label" placement="right" wrap>
    <button
      type="button"
      class="relative flex h-10 w-10 items-center justify-center text-[#525252] outline-none hover:bg-[#e8e8e8] hover:text-[#161616]"
      :class="active ? 'bg-[#e8e8e8] text-[#161616]' : ''"
      :aria-label="label"
      :aria-current="active ? 'page' : undefined"
      @click="$emit('click')"
    >
      <span
        v-if="active"
        class="absolute top-1 bottom-1 left-0 w-[3px] bg-[#4b5cda]"
        aria-hidden="true"
      />
      <Icon :name="icon" :size="20" />
    </button>
  </Tooltip>
</template>
