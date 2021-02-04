using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOUsuario
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string ApellidoPaterno { get; set; }
        public string ApellidoMaterno { get; set; }
        public string Nombres { get; set; }
        public int IdTipoUsuario { get; set; }
        public string DescripcionTipoU { get; set; }
        public int IdEstado { get; set; }
        public string DescripcionEstado { get; set; }
    }
}
