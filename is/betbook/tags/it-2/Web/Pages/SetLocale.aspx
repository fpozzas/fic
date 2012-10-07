<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
    CodeBehind="SetLocale.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.SetLocale" meta:resourcekey="Page" %>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <div id="form">
        <form id="SetLocaleForm" method="post" runat="server">
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclLanguage" runat="server" meta:resourcekey="lclLanguage" />
            </span>
            <span class="entry">
                <asp:DropDownList ID="comboLanguage" runat="server" AutoPostBack="True" Width="100px"
                    OnSelectedIndexChanged="comboLanguage_SelectedIndexChanged"></asp:DropDownList>
            </span>
        </div>
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclCountry" runat="server" meta:resourcekey="lclCountry" />
            </span>
            <span class="entry">
                <asp:DropDownList ID="comboCountry" runat="server" Width="100"></asp:DropDownList>
            </span>
        </div>
        <div class="button">
            <asp:Button ID="btnSetLocale" runat="server" OnClick="btnSetLocale_Click" meta:resourcekey="btnSetLocale" />
        </div>
        </form>
    </div>
</asp:Content>
