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
    
    public partial class Cliente
    {
        public int IdCliente { get; set; }
        public int IdPersona { get; set; }
        public System.DateTime FechaCreacion { get; set; }
        public int IdEstado { get; set; }
    
        public virtual Persona Persona { get; set; }
    }
}
