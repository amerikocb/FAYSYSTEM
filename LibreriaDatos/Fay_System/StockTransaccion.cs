//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LibreriaDatos.Fay_System
{
    using System;
    using System.Collections.Generic;
    
    public partial class StockTransaccion
    {
        public int IdTransaccion { get; set; }
        public System.DateTime FechaTransaccion { get; set; }
        public string Accion { get; set; }
        public string Operacion { get; set; }
        public int IdMaterial { get; set; }
        public Nullable<int> IdAlmacen { get; set; }
        public int StockFecha { get; set; }
        public int CantidadAlterada { get; set; }
        public int StockResultante { get; set; }
        public Nullable<int> IdUsuario { get; set; }
        public string TipoDocumento { get; set; }
        public string NumeroDocumento { get; set; }
    
        public virtual Material Material { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}
