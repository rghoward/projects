<template>
  <div class="container">
    <div class="col-sm-10">
      <h1>Report 2</h1>
      <hr>
      <el-table
        ref="multipleTable"
        :data="results"
        stripe
        style="width: 100%"
        :row-class-name="tableRowClassName"
        max-height="1050"
        max-width="1250"
      >
        <el-table-column fixed prop="name" label="Category" sortable></el-table-column>
        <el-table-column
          prop="products_in_category"
          label="Products in Category"
          sortable
          width="180"
        ></el-table-column>
        <el-table-column prop="unique_manufacturers" label="Unique Manufacturers" sortable></el-table-column>
        <el-table-column label="Avg Retail" sortable>
          <p slot-scope="{row}">${{row.avg_retail_price}}</p>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Report2",
  data() {
    return {
      results: []
    };
  },
  methods: {
    getProducts() {
      const path = "http://localhost:5000/report2";
      axios
        .get(path)
        .then(res => {
          this.results = res.data.results;
        })
        .catch(error => {
          // eslint-disable-next-lineI
          console.error(error);
        });
    }
  },
  created() {
    this.getProducts();
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
table,
th,
td {
  border: 1px solid black;
  border-collapse: collapse;
  padding: 15px;
}
</style>
