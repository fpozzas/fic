<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FindBetTypes.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.FindBetTypes"
    MasterPageFile="~/Betbook.Master" meta:resourcekey="Page"%>

<asp:Content ID="content1" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    
    <asp:Label CssClass="errorMessage" ID="lblBetOMaticErrorMessage" runat="server"
        visible="false" meta:resourcekey="lblBetOMaticErrorMessage" />
    <asp:Xml ID="aspXml" runat="server" TransformSource="XSLT/FindBetTypes.xslt" />
    
</asp:Content>
