<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="PaginaPrincipal.aspx.cs" Inherits="Fay_System.PaginaPrincipal" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" type="text/css" href="Custom_CSS/demo.css" />
    <link rel="stylesheet" type="text/css" href="Custom_CSS/slicebox.css" />
    <link rel="stylesheet" type="text/css" href="Custom_CSS/custom.css" />
    <script type="text/javascript" src="Custom_Scripts/modernizr.custom.46884.js"></script>
    <style>
        #kservicios-tit {
            color: #000000;
            cursor: default;
            top: 30px;
            left: 0;
            right: 0;
            bottom: 0;
            height: 100px;
            margin: auto;
            display: block;
            -webkit-animation: bounce .3s ease infinite alternate;
            font-size: 2.8em;
            text-align: center;
            text-shadow: 0 1px 0 #343434, 0 2px 0 #343434, 0 3px 0 #343434, 0 4px 0 #343434, 0 5px 0 #343434, 0 6px 0 transparent, 0 7px 0 transparent, 0 8px 0 transparent, 0 9px 0 transparent, 0 10px 10px rgba(0, 0, 0, 0);
        }
        /* ANIMATION */
        @-webkit-keyframes bounce {
            100% {
                top: -30px;
                text-shadow: 0 1px 0 #343434, 0 2px 0 #343434, 0 3px 0 #343434, 0 4px 0 #343434, 0 5px 0 #343434, 0 6px 0 #343434, 0 7px 0 #343434, 0 8px 0 #343434, 0 9px 0 #343434, 0 30px 30px rgba(0, 0, 0, .3);
            }
        }

        .imgMain{
            margin: 0px auto;
        }
        /*.dxisControl {
            margin: 0 auto;
        }

            .dxisControl .dxis-itemTextArea {
                top: 17px;
                left: 17px;
                bottom: auto;
                width: 285px;
                padding: 15px 16px 21px;
                color: #fff;
                border-radius: 5px;
                box-shadow: 0px 4px 0px rgba(50, 50, 50, 0.3);
                background-color: #333333;
                background-color: rgba(0, 0, 0, 0.75);
                margin: 0 auto;
            }

                .dxisControl .dxis-itemTextArea a {
                    color: white;
                }

                    .dxisControl .dxis-itemTextArea a:hover, a:focus {
                        text-decoration: underline;
                    }

                .dxisControl .dxis-itemTextArea p {
                    color: #b0b0b0;
                }

                .dxisControl .dxis-itemTextArea > p {
                    margin-bottom: 0 !important;
                }

            .dxisControl .dxis-nbDotsBottom {
                padding: 0;
                margin-top: -25px;
            }

                .dxisControl .dxis-nbDotsBottom .dxis-nbSlidePanel {
                    right: 15px;
                    left: auto !important;
                    transform: matrix(1, 0, 0, 1, 0, 0) !important;
                    -webkit-transform: matrix(1, 0, 0, 1, 0, 0) !important;
                }

        .isdemoH3 {
            font-size: 28px !important;
            color: white;
            padding-bottom: 9px;
        }*/
        .contPrinc {
            background-image: url("../imagenes/Digital-Print02.jpg");
            background-size: cover;
        }
    </style>
    <div class="container-fluid">
        <div class="row">
            <%--<h1 id="kservicios-tit"><strong><span style="color: #da251e;">MULTISERVICIOS FAYCE S.R.L.</span></strong></h1>--%>
            <dx:ASPxImage runat="server" ID="imgMain" ClientInstanceName="imgMain" Theme="Material" ImageUrl="~/imagenes/Digital-Print02.jpg" Width="85%" Height="470px" CssClass="imgMain">
            </dx:ASPxImage>
        </div>
        <%--<div class="wrapper">

            <ul id="sb-slider" class="sb-slider">
                <li>
                    <a href="#" target="_blank">
                        <img src="imagenes/Digital-Print01.jpg" alt="image1" /></a>
                    <div class="sb-description">
                        <h3>Servicio de alta calidad</h3>
                    </div>
                </li>
                <li>
                    <a href="#" target="_blank">
                        <img src="imagenes/Digital-Print02.jpg" /></a>
                    <div class="sb-description">
                        <h3>Los mejores acabados</h3>
                    </div>
                </li>
                <li>
                    <a href="#" target="_blank">
                        <img src="imagenes/Digital-Print03.jpg" /></a>
                    <div class="sb-description">
                        <h3>Calidad y excelencia a su servicio</h3>
                    </div>
                </li>
                <li>
                    <a href="#" target="_blank">
                        <img src="imagenes/Digital-Print04.jpg" /></a>
                    <div class="sb-description">
                        <h3>Responsabilidad y eficiencia</h3>
                    </div>
                </li>
                <li>
                    <a href="#" target="_blank">
                        <img src="imagenes/Digital-Print05.jpg" /></a>
                    <div class="sb-description">
                        <h3>Fayce a su servicio</h3>
                    </div>
                </li>
            </ul>

            <div id="shadow" class="shadow"></div>

            <div id="nav-arrows" class="nav-arrows">
                <a href="#">Siguiente</a>
                <a href="#">Anterior</a>
            </div>

            <div id="nav-dots" class="nav-dots">
                <span class="nav-dot-current"></span>
                <span></span>
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>--%>
    </div>
    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    <script type="text/javascript" src="Custom_Scripts/jquery.slicebox.js"></script>--%>
    <script type="text/javascript">
        //$(function () {

        //    var Page = (function () {

        //        var $navArrows = $('#nav-arrows').hide(),
        //            $navDots = $('#nav-dots').hide(),
        //            $nav = $navDots.children('span'),
        //            $shadow = $('#shadow').hide(),
        //            slicebox = $('#sb-slider').slicebox({
        //                onReady: function () {

        //                    $navArrows.show();
        //                    $navDots.show();
        //                    $shadow.show();

        //                },
        //                onBeforeChange: function (pos) {

        //                    $nav.removeClass('nav-dot-current');
        //                    $nav.eq(pos).addClass('nav-dot-current');

        //                }
        //            }),

        //            init = function () {

        //                initEvents();

        //            },
        //            initEvents = function () {

        //                // add navigation events
        //                $navArrows.children(':first').on('click', function () {

        //                    slicebox.next();
        //                    return false;

        //                });

        //                $navArrows.children(':last').on('click', function () {

        //                    slicebox.previous();
        //                    return false;

        //                });

        //                $nav.each(function (i) {

        //                    $(this).on('click', function (event) {

        //                        var $dot = $(this);

        //                        if (!slicebox.isActive()) {

        //                            $nav.removeClass('nav-dot-current');
        //                            $dot.addClass('nav-dot-current');

        //                        }

        //                        slicebox.jump(i + 1);
        //                        return false;

        //                    });

        //                });

        //            };

        //        return { init: init };

        //    })();

        //    Page.init();

        //});
    </script>
</asp:Content>
