<script setup lang="ts">
import { computed } from "vue";
import type { StepState } from "../composables/useStepper";
import iconStepCompleted from "../assets/icons/step-completed.svg?raw";
import iconStepActive from "../assets/icons/step-active.svg?raw";
import iconStepUpcoming from "../assets/icons/step-upcoming.svg?raw";

const props = defineProps<{
  label: string;
  description?: string;
  state: StepState;
}>();

const borderClass = computed(() =>
  props.state === "active" || props.state === "completed"
    ? "border-blue-500"
    : "border-neutral-300 dark:border-neutral-600",
);

const iconClass = computed(() => {
  if (props.state === "active" || props.state === "completed") return "text-blue-500";
  if (props.state === "disabled") return "text-neutral-300 dark:text-neutral-600";
  return "text-neutral-400 dark:text-neutral-500";
});

const labelClass = computed(() =>
  props.state === "disabled"
    ? "text-neutral-400 dark:text-neutral-500"
    : "text-neutral-900 dark:text-neutral-100",
);

const icon = computed(() => {
  if (props.state === "completed") return iconStepCompleted;
  if (props.state === "active") return iconStepActive;
  return iconStepUpcoming;
});
</script>

<template>
  <div
    class="flex flex-1 flex-col items-start gap-1 border-t-2 pt-2.5 pr-4 transition-colors duration-300"
    :class="borderClass"
  >
    <div class="flex items-center gap-2">
      <Transition name="step-icon" mode="out-in">
        <span :key="state" class="size-4 shrink-0" :class="iconClass" v-html="icon" />
      </Transition>
      <span class="text-sm font-medium whitespace-nowrap transition-colors duration-300" :class="labelClass">{{ label }}</span>
    </div>
    <p
      v-if="description"
      class="pl-6 text-xs text-neutral-500 dark:text-neutral-400"
    >
      {{ description }}
    </p>
  </div>
</template>

<style scoped>
.step-icon-enter-active,
.step-icon-leave-active {
  transition:
    opacity 0.2s ease,
    transform 0.2s ease;
}
.step-icon-enter-from,
.step-icon-leave-to {
  opacity: 0;
  transform: scale(0.5);
}

.size-4 :deep(svg) {
  display: block;
  width: 100%;
  height: 100%;
}
</style>
