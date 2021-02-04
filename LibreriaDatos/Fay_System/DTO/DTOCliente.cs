using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOCliente
    {
        public int IdCliente { get; set; }
        public string ApellidoPaterno { get; set; }
        public string ApellidoMaterno { get; set; }
        public string Nombres { get; set; }
        public string Dni { get; set; }
        public string Ruc { get; set; }
        public DateTime? FechaNacimiento { get; set; }
        public string Direccion { get; set; }
        public string Estado { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public int IdEstado { get; set; }
        public int IdProvincia { get; set; }
        public int IdDepartamento { get; set; }
        public string Provincia { get; set; }
        public string Departamento { get; set; }
        public string Sexo { get; set; }
    }
}
