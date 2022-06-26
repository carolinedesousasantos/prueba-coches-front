<template>
  <div>
    <v-container>
      <v-card elevation="5">
        <v-simple-table fixed-header height="460px">
          <template v-slot:default>
            <thead>
              <tr>
                <th class="text-left">Modelo</th>
                <th class="text-left">Cantidad</th>
                <th class="text-left">Precio</th>
                <th class="text-left">Disponible</th>
                <th class="text-left">Acción</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="coche in coches" :key="coche.id">
                <td>{{ coche.modelo }}</td>
                <td>{{ coche.cantidad }}</td>
                <td>{{ coche.precio.toFixed(2) }}</td>
                <td>
                  <v-checkbox v-model="coche.disponible" @change="updateDisponible(coche.id, coche.disponible)"
                  >
                  </v-checkbox>
                </td>

                <td>
                  <v-btn icon color="primary"
                    @click="$router.push({ name: 'FormCochesView', params: { id: coche.id } })">
                    <v-icon> mdi-lead-pencil</v-icon>
                  </v-btn>

                  <v-btn icon :icarId="coche.id" color="error" @click="setCarID(coche.id)">
                    <v-icon> mdi-close</v-icon>
                  </v-btn>

                </td>

              </tr>
            </tbody>

          </template>

        </v-simple-table>

        <v-card-actions>

          <v-btn id="btn-redirect-create" color="primary"
            @click="$router.push({ name: 'FormCochesView', params: { id: undefined } })">
            <v-icon> mdi-plus </v-icon> Registrar
          </v-btn>
        </v-card-actions>

      </v-card>
      <v-alert :value="showAlert" dense text transition="scale-transition" type="error" dismissible>{{ responseMsg }}
      </v-alert>

      <v-row justify="center">
        <v-dialog v-model="dialog" persistent max-width="300">

          <v-card>
            <v-card-title class="text-center">
              ¿Deseas borrar el coche?
            </v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="green darken-1" text @click="dialog = false">
                No
              </v-btn>
              <v-btn color="green darken-1" text @click="deleteCar()">
                Sí
              </v-btn>
            </v-card-actions>
          </v-card>

        </v-dialog>
      </v-row>
    </v-container>
  </div>
</template>
<style>
.v-main .v-card {
  margin: 30px;
}

.v-dialog .v-card {
  margin-bottom: 0;
}

.v-data-table {
  margin-bottom: 50px;
}

#btn-redirect-create {
  position: absolute;
  right: 20px;
  bottom: 10px;
}
</style>
    
<script>
const axios = require('axios').default;
var backEndHost = process.env.BACKENDHOST || 'http://localhost:8080';
export default {
  name: "TableCoches",
  data() {
    return {
      coches: [],
      dialog: false,
      carId: 0,
      showAlert: false,
      responseMsg: ""
    }
  },
  methods: {
    getList() {
      var self = this;
      axios({
        method: 'get',
        url: `${backEndHost}/cars`,
        responseType: 'application/json'
      })
        .then(function (response) {
          self.coches = response.data;
        });
    },
    updateDisponible(id, disponible) {
      console.log(id, disponible)
      var self = this;
      axios({
        method: 'put',
        url: `${backEndHost}/cars/disponible/${id}/${disponible}`,
        responseType: 'application/json',
      })
        .then(function () {

        }).catch(function (error) {
          self.showAlert = true;
          self.alertType = "error";
          self.responseMsg = error;
        })
    },
    setCarID(id) {
      this.carId = id;
      this.dialog = true;
    },
    deleteCar() {
      console.log(this.carId)
      var self = this;
      this.dialog = false;

      axios({
        method: 'delete',
        url: `${backEndHost}/cars/${self.carId}`,

      })
        .then(function () {
          self.carId = 0;
          location.reload();
        })
        .catch(function (error) {
          self.showAlert = true;
          self.responseMsg = error;
        });
    }
  },
  mounted: function () {
    this.getList();
  }
}
</script>