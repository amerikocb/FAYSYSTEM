namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOComprobanteDetalle
    {
        public int Id { get; set; }
        public string Servicio { get; set; }
        public string Material { get; set; }
        public string Almacen { get; set; }
        public int? Cantidad { get; set; }
        public string UnidadMedida { get; set; }
        public decimal? Precio { get; set; }
        public decimal? Importe { get; set; }
    }
}
