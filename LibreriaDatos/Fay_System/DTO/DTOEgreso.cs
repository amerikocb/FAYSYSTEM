using System;

namespace LibreriaDatos.DTO
{
    public class DTOEgreso
    {
        public int Id { get; set; }
        public string Motivo { get; set; }
        public decimal? Monto { get; set; }
        public string Empleado { get; set; }
        public string Usuario { get; set; }
        public DateTime? Fecha { get; set; }
        public string Estado { get; set; }
    }
}
