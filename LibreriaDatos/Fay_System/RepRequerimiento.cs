using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepRequerimiento:Repositorio<Requerimiento>
    {
        public RepRequerimiento(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTORequerimientos> ObtenerListaRequerimientos()
        {
            return (from r in _contexto.Requerimiento
                    join u in _contexto.Usuario on r.IdUsuario equals u.id
                    join e in _contexto.Estado on r.IdEstado equals e.Id
                    select new DTORequerimientos{
                        Id=r.Id,
                        Fecha=r.FechaCreacion,
                        Usuario=u.Nombre,
                        EstadoRequerimiento=e.Descripcion
                    }).OrderByDescending(r =>r.Fecha).ToList();
        }
        public List<DTORequerimientos> ObtenerListaRequerimientosPendientesDeAprobacion()
        {
            return (from r in _contexto.Requerimiento
                    join u in _contexto.Usuario on r.IdUsuario equals u.id
                    join e in _contexto.Estado on r.IdEstado equals e.Id
                    where r.IdEstado == 26
                    select new DTORequerimientos
                    {
                        Id = r.Id,
                        Fecha = r.FechaCreacion,
                        Usuario = u.Nombre,
                        EstadoRequerimiento = e.Descripcion
                    }).OrderByDescending(r => r.Fecha).ToList();
        }
        public int? ObtenerEstadoRequerimiento(int IdRequerimiento)
        {
            return (from r in _contexto.Requerimiento
                    where r.Id == IdRequerimiento
                    select r.IdEstado).FirstOrDefault();
        }
    }
}
