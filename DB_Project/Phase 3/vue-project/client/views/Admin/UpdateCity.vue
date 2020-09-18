<template>
  <div class="hello">
          <h1>Manage City Population</h1>
          <br>
<!-- Add below line of code for row click events   
	@row-click="handle" 

    Line below is for alternating row coloring
    :row-class-name="tableRowClassName"
-->
<form>
<el-table
   ref="multipleTable"
    :data="results"
    :default-sort = "{prop: 'State', order: 'ascending'}"
     style="width: 100%"
     max-height="1050" 
     max-width="1250" 
>
    <el-table-column
      prop="state_name"
      label="State"
      sortable
	>
    </el-table-column>
    <el-table-column
      prop="city_name"
      label="City"
      sortable >
    </el-table-column>
    <el-table-column
      prop="population"
      label="Popuation"
      sortable>
    </el-table-column>
 <el-table-column
      fixed="right"
      label="Operations"
      width="250">
      <template scope="scope">
        <el-button @click="handleClick(scope.$index,results)" type="text" size="small">Update</el-button>
   		<input class="form-control" type="number" :id=results[scope.$index].id >
      </template>
    </el-table-column>
  </el-table>
   </form>
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
  name: "UpdateCity",
  data() {
    return {
      results: []
    };
  },
  computed: {
    postId () {
      return this.$route.params.id
    }
  },
  methods: {
    getProducts() {
      const path = "http://localhost:5000/city_population";
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
	tableRowClassName(row, index) {
        if (index % 2 == 0) {
          return 'info-row';
        } else {
          return 'positive-row';
        }
        return '';
    },
	handleClick(index,results) {
      var x = document.getElementById(results[index].id).value;
        this.$alert('city id=' + results[index].id + "New Population=" + x + " Old Population:" + results[index].population, results[index].city_name + "," +  results[index].state_name , {
          confirmButtonText: 'OK',
          /*callback: action => {
            this.$message({
              type: 'info',
              message: `action: ${ action }`
            });
          }*/
        });

	},
   open2() {
        this.$confirm('This will permanently delete the file. Continue?', 'Warning', {
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          this.$message({
            type: 'success',
            message: 'Delete completed'
          });
        }).catch(() => {
          this.$message({
            type: 'info',
            message: 'Delete canceled'
          });          
        });
      },
 	handle(row, event, column) {
        //   console.log(row, event, column)
        this.$alert('This is a message' + row.id, row.name, {
          confirmButtonText: 'OK',
          /*callback: action => {
            this.$message({
              type: 'info',
              message: `action: ${ action }`
            });
          }*/
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
