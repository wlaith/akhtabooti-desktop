<script setup lang="ts">
import { useI18n } from "vue-i18n";
import type { StepDefinition, StepState } from "../composables/useStepper";
import StepperItem from "./StepperItem.vue";

defineProps<{
  steps: StepDefinition[];
  stateOf: (index: number) => StepState;
  currentIndex: number;
}>();

const emit = defineEmits<{
  (e: "select", index: number): void;
}>();

const { t } = useI18n();
</script>

<template>
  <div>
    <p class="mb-2 text-xs text-text-primary/60">
      {{ t("stepper.stepOfTotal", { current: currentIndex + 1, total: steps.length }) }}
    </p>
    <div class="flex w-full items-start" role="list">
      <StepperItem
        v-for="(step, index) in steps"
        :key="step.label"
        :label="step.label"
        :description="step.description"
        :state="stateOf(index)"
        @select="emit('select', index)"
      />
    </div>
  </div>
</template>
