<template>
  <div class="container">
    <h1>Report 1 Drill Down</h1>
    <br>
    <!-- Add below line of code for row click events   
	@row-click="handle" 
    -->
    <el-table
      ref="multipleTable"
      :data="headerData"
      stripe
      :default-sort="{prop: 'ID', order: 'descending'}"
      style="width: 100%"
      max-height="1050"
      max-width="1250"
    >
      <el-table-column fixed prop="id" label="ID"></el-table-column>
      <el-table-column prop="name" label="Manufacturer" width="180"></el-table-column>
      <el-table-column prop="total_products" label="Products"></el-table-column>
      <el-table-column label="Avg Retail">
        <p slot-scope="{row}">${{row.avg_retail_price}}</p>
      </el-table-column>
      <el-table-column label="Min Retail">
        <p slot-scope="{row}">${{row.min_retail_price}}</p>
      </el-table-column>
      <el-table-column label="Max Retail">
        <p slot-scope="{row}" align="center">${{row.max_retail_price}}</p>
      </el-table-column>
    </el-table>

    <el-table
      ref="multipleTable"
      :data="results"
      :default-sort="{prop: 'retail_price', order: 'ascending'}"
      style="width: 100%"
    >
      <el-table-column fixed prop="pid" label="PID"></el-table-column>
      <el-table-column prop="product_name" label="Name"></el-table-column>
      <el-table-column prop="category_name" label="Category"></el-table-column>
      <el-table-column prop="retail_price" label="Retail" sortable>
        <p slot-scope="{row}" >${{row.retail_price}}</p>
      </el-table-column>
    </el-table>
  </div>
</template>

<style>
.el-table .info-row {
  background: #c9e5f5;
}

.el-table .positive-row {
  background: #e2f0e4;
}
</style>

<script>
import axios from "axios";

export default {
  name: "Report1Drill",
  data() {
    return {
      results: []
    };
  },
  computed: {
    postId() {
      return this.$route.params.id;
    }
  },
  methods: {
    getProducts() {
      const path =
        "http://localhost:5000/report1_drill_down?manufacturer_id=" +
        this.$route.params.id;
      axios
        .get(path)
        .then(res => {
          this.results = res.data.results;
        })
        .catch(error => {
          // eslint-disable-next-lineI
          console.error(error);
        });
    },
    getHeaderData() {
      const path =
        "http://localhost:5000/report1?manufacturer_id=" +
        this.$route.params.id;
      axios
        .get(path)
        .then(res => {
          this.headerData = res.data.results;
        })
        .catch(error => {
          // eslint-disable-next-lineI
          console.error(error);
        });
    }
  },

  created() {
    this.getHeaderData();
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
