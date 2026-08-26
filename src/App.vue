<script setup lang="ts">
import { ref } from "vue";
import { invoke } from "@tauri-apps/api/core";
import { useStepper } from "./composables/useStepper";
import Stepper from "./components/Stepper.vue";
import ConfigureScan from "./components/configure-scan/ConfigureScan.vue";

interface FilePIIs {
  filename: string;
  email_accounts: string[];
  phone_numbers: string[];
  other_piis: string[];
}

const results = ref<FilePIIs[]>([]);
const scanning = ref(false);
const error = ref("");
const hasScanned = ref(false);

const steps = [{ label: "Configure" }, { label: "Scan" }, { label: "Results" }];
const stepper = useStepper(steps);

async function scan(paths: string[]) {
  if (paths.length === 0) return;

  error.value = "";
  scanning.value = true;
  hasScanned.value = true;
  results.value = [];
  stepper.goTo(1);

  try {
    const scanned = await Promise.all(
      paths.map((path) => invoke<FilePIIs[]>("scan_path", { path })),
    );
    results.value = scanned.flat();
  } catch (e) {
    error.value = String(e);
  } finally {
    scanning.value = false;
    stepper.goTo(2);
  }
}

function hasFindings(file: FilePIIs) {
  return (
    file.email_accounts.length > 0 ||
    file.phone_numbers.length > 0 ||
    file.other_piis.length > 0
  );
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
      <ConfigureScan :disabled="scanning" @start-scan="scan" />

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
