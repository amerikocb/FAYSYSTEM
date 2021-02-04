using LibreriaDatos.Fay_System.DTO;
using System.Collections.Generic;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public  class RepServicios:Repositorio<Servicio>
    {
        public RepServicios(FayceEntities contexto) : base(contexto)
        {
            
        }
        public List<DTOServicio> ObtenerServicios()
        {
            return (from s in _contexto.Servicio
                    join e in _contexto.Estado on s.IdEstado equals e.Id
                    join u in _contexto.Usuario on s.IdUsuario equals u.id
                    select new DTOServicio
                    {
                        Id = s.Id,
                        Codigo = s.CodigoServicio,
                        Descripcion = s.Descripcion,
                        Estado = e.Descripcion ,
                        Usuario = u.Nombre,
                        FechaCreacion = s.FechaCreacion

                    }).OrderByDescending(s => s.Id).ToList();
        }

        public double? ObtenerPrecioServicio(int IdServicio)
        {
            Servicio s = _contexto.Servicio.Where(se => se.Id == IdServicio).FirstOrDefault();
            return s.Precio;
        }
    }
}
