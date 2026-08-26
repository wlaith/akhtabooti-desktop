<script setup lang="ts">
import { useStepper } from "./composables/useStepper";
import { useScan } from "./composables/useScan";
import Stepper from "./components/Stepper.vue";
import ConfigureScan from "./components/configure-scan/ConfigureScan.vue";

const steps = [{ label: "Configure" }, { label: "Scan" }, { label: "Results" }];
const stepper = useStepper(steps);
const { results, scanning, error, hasScanned, scan, hasFindings } = useScan();

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

      <ul v-else-if="hasScanned" class="mt-8 space-y-3 text-left">
      <li v-if="results.length === 0" class="text-neutral-500 dark:text-neutral-400">
        No files found.
      </li>
      <li
        v-for="file in results"
        :key="file.filename"
        class="rounded-lg border border-neutral-200 bg-white p-4 dark:border-neutral-600 dark:bg-neutral-700"
      >
        <div class="mb-2 font-semibold break-all">{{ file.filename }}</div>
        <div v-if="hasFindings(file)" class="flex flex-wrap gap-2">
          <span
            v-if="file.email_accounts.length"
            class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800 dark:bg-red-900/40 dark:text-red-300"
          >
            {{ file.email_accounts.length }} email{{ file.email_accounts.length > 1 ? "s" : "" }}
          </span>
          <span
            v-if="file.phone_numbers.length"
            class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800 dark:bg-red-900/40 dark:text-red-300"
          >
            {{ file.phone_numbers.length }} phone number{{ file.phone_numbers.length > 1 ? "s" : "" }}
          </span>
          <span
            v-for="tag in file.other_piis"
            :key="tag"
            class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800 dark:bg-red-900/40 dark:text-red-300"
          >
            {{ tag }}
          </span>
        </div>
        <div v-else class="text-sm text-green-600 dark:text-green-400">No PII detected</div>
      </li>
    </ul>
    </div>
  </main>
</template>
