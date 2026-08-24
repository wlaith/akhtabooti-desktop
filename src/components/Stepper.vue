<script setup lang="ts">
import type { StepDefinition, StepState } from "../composables/useStepper";
import StepperItem from "./StepperItem.vue";

defineProps<{
  steps: StepDefinition[];
  stateOf: (index: number) => StepState;
}>();
</script>

<template>
  <div class="flex w-full items-start">
    <StepperItem
      v-for="(step, index) in steps"
      :key="step.label"
      :label="step.label"
      :description="step.description"
      :state="stateOf(index)"
    />
  </div>
</template>
