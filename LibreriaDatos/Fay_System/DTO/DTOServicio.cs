using System;

namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOServicio
    {
        public int Id { get; set; }
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
        public int IdEstado { get; set; }
        public DateTime? FechaCreacion { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public double? Precio { get; set; }
        public int? IdUsuario { get; set; }
    }
}
