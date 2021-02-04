﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioEmpresa
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioEmpresa: Repositorio<Empresa>, IRepositorioEmpresa
    {
        public RepositorioEmpresa(FayceEntities contexto) : base(contexto)
        {
        }
    }
}
