import { computed, reactive, ref } from "vue";

export interface StepDefinition {
  label: string;
  description?: string;
  disabled?: boolean;
}

export type StepState = "completed" | "active" | "upcoming" | "disabled";

export function useStepper(steps: StepDefinition[], initialIndex = 0) {
  const currentIndex = ref(initialIndex);
  const completed = reactive(new Set<number>());

  const currentStep = computed(() => steps[currentIndex.value]);
  const isFirst = computed(() => currentIndex.value === 0);
  const isLast = computed(() => currentIndex.value === steps.length - 1);

  function stateOf(index: number): StepState {
    if (completed.has(index)) return "completed";
    if (index === currentIndex.value) return "active";
    if (steps[index]?.disabled) return "disabled";
    return index < currentIndex.value ? "completed" : "upcoming";
  }

  function complete(index: number) {
    completed.add(index);
  }

  function clearCompleted() {
    completed.clear();
  }

  function goTo(index: number) {
    if (index < 0 || index >= steps.length || steps[index]?.disabled) return;
    currentIndex.value = index;
  }

  function next() {
    if (!isLast.value) goTo(currentIndex.value + 1);
  }

  function prev() {
    if (!isFirst.value) goTo(currentIndex.value - 1);
  }

  return {
    currentIndex,
    currentStep,
    isFirst,
    isLast,
    stateOf,
    goTo,
    next,
    prev,
    complete,
    clearCompleted,
  };
}
