<template>
<header>
    <el-menu theme="dark" mode="horizontal">
        <el-menu-item class="header-navicon" index="1">
            <el-button type="text" @click="openSidebar">
                <i class="md-icon">menu</i>
            </el-button>
        </el-menu-item>
    <el-submenu class="header-menu" index="3">
            <template slot="title">Workspace</template>
                <el-menu-item index="4-1">item one</el-menu-item>
                <el-menu-item index="4-2">item two</el-menu-item>
                <el-menu-item index="4-3">item three</el-menu-item>
            </el-submenu>
    <el-submenu theme="light" mode="horizontal" index="2">
        <template slot="title">SEDW Statistics</template>
        <span class="header-title">{{title}}</span>
      <table class="table table-hover">
          <thead>
            <tr>
              <th scope="col">Store Count</th>
              <th scope="col">Active Managers</th>
              <th scope="col">Inactive Managers</th>
              <th scope="col">Products</th>
              <th scope="col">Manufacturers</th>
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
            </tr>
          </tbody>
        </table>
        </el-submenu>
        </el-menu>

            </header>
</template>

<script>
import axios from 'axios';

export default {
  name: 'Header',
  props: ['openSidebar', 'title'],

  data () {
    return {
      results: []
    };
  },
  methods: {
    getMainMenuStats () {
      const path = 'http://localhost:5000/main_menu_statistics';
      axios.get(path)
        .then((res) => {
          this.results = res.data.results;
          console.log(res)
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    }
  },
  created () {
    this.getMainMenuStats();
  }
};


</script>

<style lang="scss">
// You can import all your SCSS variables using webpack alias
@import '~scss_vars';
@import './style.scss';
</style>
