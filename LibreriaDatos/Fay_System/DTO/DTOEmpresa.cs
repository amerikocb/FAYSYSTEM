using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOEmpresa
    {
        public int Id { get; set; }
        public string RazonSocial { get; set; }
        public string RUC { get; set; }
        public string Direccion { get; set; }
        public string Estado { get; set; }
        public string Email { get; set; }
        public string PaginaWeb { get; set; }
        public string Telefono { get; set; }
        public bool? Proveedor { get; set; }
        public int IdEstado { get; set; }
    }
}
