<template>
  <div class="container">
    <div class="row">
      <div class="col-sm-10">
        <h1>SEDW Statistics</h1>
        <hr><br><br>
        <button type="button" class="btn btn-success btn-sm">Add Book</button>
        <br><br>
        <table class="table table-hover">
          <thead>
            <tr>
              <th scope="col">Title</th>
              <th scope="col">Author</th>
              <th scope="col">Read?</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, index) in results" :key="index">
              <td>{{ row.store_count }}</td>
              <td>{{ row.active_managers }}</td>
              <td>{{ row.inactive_managers }}</td>
              <td>{{ row.products }}</td>
              <td>{{ row.manufacturers }}</td>
			<!-- Comment -->
              <td>
                <span v-if="book.read">Yes</span>
                <span v-else>No</span>
              </td>
              <td>
                <button type="button" class="btn btn-warning btn-sm">Update</button>
                <button type="button" class="btn btn-danger btn-sm">Delete</button>
			<!-- Comment -->
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      stats: [],
    };
  },
  methods: {
    getMainMenuStats() {
      const path = 'http://localhost:8081/main_menu_statistics';
      axios.get(path)
        .then((res) => {
          this.stats = res.data.results;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
  },
  created() {
    this.getMainMenuStats();
  },
};
</script>
