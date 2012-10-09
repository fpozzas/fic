<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserCreated.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.UserCreated" MasterPageFile="~/Betbook.Master"
    meta:resourcekey="Page" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <p>
        <asp:Label ID="lblAccCreatedTitle" runat="server" meta:resourcekey="lblUserCreated" />
    </p>
    <p>
        <asp:Label ID="lblAccCreatedSubTitle" runat="server" meta:resourcekey="lblUserCreatedId" />:
        <strong>
            <asp:Label ID="lblUserCreatedId" runat="server" />
        </strong>
    </p>
</asp:Content>
