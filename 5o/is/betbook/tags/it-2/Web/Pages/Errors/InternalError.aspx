<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
    Codebehind="InternalError.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.Errors.InternalError" 
    meta:resourcekey="Page" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain"
    runat="server">

    <br />
    <br />
    <asp:Label ID="lblErrorTitle" runat="server" 
        meta:resourcekey="lblErrorTitle"/>
    <br />
    <br />
    <asp:Label ID="lblRetryLater" runat="server" 
        meta:resourcekey="lblRetryLater"/>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />

    <asp:Localize ID="lclContent" runat="server" meta:resourcekey="lclContent" />

</asp:Content>