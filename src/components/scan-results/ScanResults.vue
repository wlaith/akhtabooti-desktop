<script setup lang="ts">
import { computed } from "vue";
import type { FilePIIs } from "../../composables/useScan";
import List from "../list/List.vue";
import Accordion from "../accordion/Accordion.vue";
import AccordionItem from "../accordion/AccordionItem.vue";
import StatTile from "../stat-tile/StatTile.vue";

const props = defineProps<{ results: FilePIIs[] }>();

function hasFindings(file: FilePIIs) {
  return (
    file.email_accounts.length > 0 ||
    file.phone_numbers.length > 0 ||
    file.other_piis.length > 0
  );
}

const filesWithFindings = computed(() => props.results.filter(hasFindings));
const totalEmails = computed(() =>
  props.results.reduce((sum, file) => sum + file.email_accounts.length, 0),
);
const totalPhones = computed(() =>
  props.results.reduce((sum, file) => sum + file.phone_numbers.length, 0),
);
</script>

<template>
  <section class="w-full text-left">
    <h2 class="mb-6 text-[28px] font-semibold text-[#161616]">Scan Result</h2>

    <div class="mb-6 flex gap-6">
      <StatTile label="Paths scanned" :value="results.length" />
      <StatTile label="Files with findings" :value="filesWithFindings.length" />
      <StatTile label="Emails found" :value="totalEmails" />
      <StatTile label="Phone numbers found" :value="totalPhones" />
    </div>

    <p v-if="results.length === 0" class="text-[#525252]">No files found.</p>
    <List v-else title="Result">
      <Accordion>
        <AccordionItem v-for="file in results" :key="file.filename" :title="file.filename">
          <template v-if="hasFindings(file)">
            <div v-if="file.email_accounts.length">
              <div class="mb-1 font-semibold">Emails ({{ file.email_accounts.length }})</div>
              <ul class="list-disc space-y-0.5 pl-5">
                <li v-for="email in file.email_accounts" :key="email" class="break-all">
                  {{ email }}
                </li>
              </ul>
            </div>
            <div v-if="file.phone_numbers.length">
              <div class="mb-1 font-semibold">
                Phone numbers ({{ file.phone_numbers.length }})
              </div>
              <ul class="list-disc space-y-0.5 pl-5">
                <li v-for="phone in file.phone_numbers" :key="phone">{{ phone }}</li>
              </ul>
            </div>
            <div v-if="file.other_piis.length">
              <div class="mb-1 font-semibold">Other</div>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="tag in file.other_piis"
                  :key="tag"
                  class="rounded-full bg-red-100 px-3 py-0.5 text-sm text-red-800"
                >
                  {{ tag }}
                </span>
              </div>
            </div>
          </template>
          <p v-else class="text-green-600">No PII detected</p>
        </AccordionItem>
      </Accordion>
    </List>
  </section>
</template>
