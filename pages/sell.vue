<template>
    <section class="section">
        <div class="container">
            <div class="field">
                <label class="label">Axie Id</label>
                <div class="control">
                    <input class="input" type="text" placeholder="Text input">
                </div>
            </div>

            <div class="field">
                <label class="label">Number of Shares you want to sell</label>
                <div class="control">
                    <input class="input" type="number" placeholder="Text input" value="0">
                </div>
            </div>

            <div class="field">
                <label class="label">Price of each share</label>
                <div class="control">
                    <input class="input" type="number" placeholder="Text input" value="0">
                </div>
            </div>

            <div class="field is-grouped">
                <div class="control">
                    <button class="button is-link">Submit</button>
                </div>
            </div>
        </div>
    </section>
</template>

<script>
import Card from "~/components/Card";

export default {
  name: "Sell",

  components: {
    Card
  }
};
</script>
