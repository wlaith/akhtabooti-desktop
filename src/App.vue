<script setup lang="ts">
import { useStepper } from "./composables/useStepper";
import { useScan } from "./composables/useScan";
import Stepper from "./components/Stepper.vue";
import ConfigureScan from "./components/configure-scan/ConfigureScan.vue";
import ScanResults from "./components/scan-results/ScanResults.vue";

const steps = [{ label: "Configure" }, { label: "Scan" }, { label: "Results" }];
const stepper = useStepper(steps);
const { results, scanning, error, hasScanned, scan } = useScan();

async function startScan(paths: string[]) {
  stepper.goTo(1);
  await scan(paths);
  stepper.goTo(2);
}
</script>

<template>
  <main
    class="flex min-h-screen flex-col items-center bg-neutral-100 px-4 pt-[8vh] pb-8 text-center font-sans text-neutral-900 dark:bg-neutral-800 dark:text-neutral-100"
  >
    <Stepper class="mb-6 w-full" :steps="steps" :state-of="stepper.stateOf" />

    <h1 class="text-2xl font-bold">Akhtabooti</h1>
    <p class="mx-auto mt-2 mb-6 max-w-md text-neutral-500 dark:text-neutral-400">
      Scan a file or folder on this device for personal information (PII).
      Everything runs locally — nothing leaves your computer.
    </p>

    <div class="mx-auto w-full max-w-4xl">
      <ConfigureScan :disabled="scanning" @start-scan="startScan" />

      <p v-if="scanning" class="mt-6 text-center">Scanning…</p>
      <p v-else-if="error" class="mt-6 text-center text-red-600 dark:text-red-400">
        {{ error }}
      </p>

      <ScanResults v-else-if="hasScanned" class="mt-8" :results="results" />
    </div>
  </main>
</template>
