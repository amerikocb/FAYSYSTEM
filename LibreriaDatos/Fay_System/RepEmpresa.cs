using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepEmpresa : Repositorio<Empresa>
    {
        public RepEmpresa(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOEmpresa> ObtenerListaEmpresas()
        {
            return (from e in _contexto.Empresa
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    join es in _contexto.Estado on e.IdEstado equals es.Id
                    select new DTOEmpresa
                    {
                        Id = e.Id,
                        RUC = p.Ruc,
                        RazonSocial = p.RazonSocial,
                        Direccion = p.Direccion,
                        Proveedor = e.Proveedor,
                        Estado = es.Descripcion

                    }).OrderByDescending(e => e.Id).ToList();
        }

        public List<DTOEmpresa> ObtenerListaProveedores()
        {
            return (from e in _contexto.Empresa
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    join es in _contexto.Estado on e.IdEstado equals es.Id
                    where e.Proveedor == true 
                    select new DTOEmpresa
                    {
                        Id = e.Id,
                        RUC = p.Ruc,
                        RazonSocial = p.RazonSocial,
                        Direccion = p.Direccion,
                        Proveedor = e.Proveedor,
                        Estado = es.Descripcion

                    }).OrderByDescending(e => e.Id).ToList();
        }

        public DTOEmpresa Obtener_DTOEmpresa_x_idEmpresa(int idEmpresa)
        {
            return (from e in _contexto.Empresa
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    join es in _contexto.Estado on e.IdEstado equals es.Id
                    where e.Id == idEmpresa
                    select new DTOEmpresa
                    {
                        Id = e.Id,
                        RUC = p.Ruc,
                        Email = p.Email,
                        PaginaWeb = p.PaginaWeb,
                        Telefono = p.Telefono,
                        RazonSocial = p.RazonSocial,
                        Direccion = p.Direccion,
                        Proveedor = e.Proveedor,
                        Estado = es.Descripcion,
                        IdEstado = es.Id,
                    })
                    .FirstOrDefault();
        }


        public List<DTOOrdenesCompra> ObtenerListaOrdenesCompra()
        {
            return (from o in _contexto.OrdenCompra
                    join u in _contexto.Usuario on o.IdUsuario equals u.id
                    join e in _contexto.Estado on o.IdEstado equals e.Id
                    join em in _contexto.Empresa on o.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    select new DTOOrdenesCompra
                    {
                        Id = o.Id,
                        Fecha = o.FechaCreacion,
                        Usuario = u.Nombre,
                        Estado = e.Descripcion,
                        RazonSocial = p.RazonSocial,
                        DocumentoReferencia = o.DocumentoReferencia,
                        NRequerimiento = o.IdRequerimiento
                    }).OrderByDescending(o => o.Fecha).ToList();
        }
        public DTOOrdenesCompra ObtenerOrdenCompraPorId(int IdOrdenCompra)
        {
            return (from o in _contexto.OrdenCompra
                    join u in _contexto.Usuario on o.IdUsuario equals u.id
                    join e in _contexto.Estado on o.IdEstado equals e.Id
                    join em in _contexto.Empresa on o.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    select new DTOOrdenesCompra
                    {
                        Id = o.Id,
                        Fecha = o.FechaCreacion,
                        Usuario = u.Nombre,
                        Estado = e.Descripcion,
                        RazonSocial = p.RazonSocial,
                        DocumentoReferencia = o.DocumentoReferencia,
                        NRequerimiento = o.IdRequerimiento
                    }).OrderByDescending(o => o.Fecha).FirstOrDefault();
        }

    }
}
