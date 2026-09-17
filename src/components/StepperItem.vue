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

const emit = defineEmits<{
  (e: "select"): void;
}>();

const clickable = computed(() => props.state === "completed");

const statusLabel = computed(() => {
  switch (props.state) {
    case "completed":
      return "Completed";
    case "active":
      return "Current step";
    case "disabled":
      return "Disabled";
    default:
      return "Upcoming";
  }
});

const borderClass = computed(() =>
  props.state === "active" || props.state === "completed"
    ? "border-action-primary"
    : "border-text-primary/20",
);

const iconClass = computed(() => {
  if (props.state === "active" || props.state === "completed") return "text-action-primary";
  if (props.state === "disabled") return "text-text-primary/20";
  return "text-text-primary/40";
});

const labelClass = computed(() =>
  props.state === "disabled" ? "text-text-primary/40" : "text-text-primary",
);

const icon = computed(() => {
  if (props.state === "completed") return iconStepCompleted;
  if (props.state === "active") return iconStepActive;
  return iconStepUpcoming;
});

const headerAttrs = computed(() => {
  const attrs: Record<string, string> = {};
  if (clickable.value) attrs.type = "button";
  if (props.state === "active") attrs["aria-current"] = "step";
  if (props.state === "disabled") attrs["aria-disabled"] = "true";
  return attrs;
});
</script>

<template>
  <div
    class="flex flex-1 flex-col items-start gap-1 border-t-2 pt-2.5 pr-4 transition-colors duration-300"
    :class="borderClass"
    role="listitem"
  >
    <component
      :is="clickable ? 'button' : 'div'"
      v-bind="headerAttrs"
      class="flex items-center gap-2 rounded-sm"
      :class="clickable ? 'cursor-pointer hover:opacity-80 focus-visible:outline focus-visible:outline-2 focus-visible:outline-action-primary focus-visible:outline-offset-2' : ''"
      @click="clickable && emit('select')"
    >
      <Transition name="step-icon" mode="out-in">
        <span :key="state" class="size-4 shrink-0" :class="iconClass" aria-hidden="true" v-html="icon" />
      </Transition>
      <span class="text-sm font-medium whitespace-nowrap transition-colors duration-300" :class="labelClass">
        {{ label }}
        <span class="sr-only">({{ statusLabel }})</span>
      </span>
    </component>
    <p
      v-if="description"
      class="pl-6 text-xs text-text-primary/60"
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
