<script setup lang="ts">
import { useStepper } from "./composables/useStepper";
import { useScan } from "./composables/useScan";
import Stepper from "./components/Stepper.vue";
import ConfigureScan from "./components/configure-scan/ConfigureScan.vue";
import ScanProgress from "./components/scan-progress/ScanProgress.vue";
import ScanResults from "./components/scan-results/ScanResults.vue";

const steps = [{ label: "Configure" }, { label: "Scan" }, { label: "Results" }];
const stepper = useStepper(steps);
const { results, pathStatus, scanning, error, hasScanned, scan } = useScan();

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

    <div class="mx-auto w-full max-w-4xl">
      <ConfigureScan v-if="!scanning && !hasScanned" @start-scan="startScan" />
      <ScanProgress v-else-if="scanning" :path-status="pathStatus" />
      <p v-else-if="error" class="mt-6 text-center text-red-600 dark:text-red-400">
        {{ error }}
      </p>
      <ScanResults v-else-if="hasScanned" :results="results" />
    </div>
  </main>
</template>
