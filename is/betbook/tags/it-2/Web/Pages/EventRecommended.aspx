<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventRecommended.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.EventRecommended" MasterPageFile="~/Betbook.Master"
    meta:resourcekey="Page" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <p>
        <asp:Label ID="lblEventRecommended" runat="server" meta:resourcekey="lblEventRecommended" />
    </p>
    <p>
        <asp:HyperLink ID="lnkViewRecommendations" meta:resourcekey="lblViewRecommendations" runat="server" />
    </p>
</asp:Content>
