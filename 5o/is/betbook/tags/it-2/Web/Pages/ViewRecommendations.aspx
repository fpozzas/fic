<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
CodeBehind="ViewRecommendations.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.ViewRecommendations" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <br />
    <p>
        <asp:Label ID="lblNoRecommendations" meta:resourcekey="lblNoRecommendations" runat="server"></asp:Label>
    </p>
    <form id="form" runat="server">
    <asp:GridView ID="gvViewRecommendations" runat="server" CssClass="cooltable" GridLines="None"
        AutoGenerateColumns="False" >
        <Columns>
            <asp:HyperLinkField meta:resourcekey="colEventName" DataTextField="eventName"
                DataNavigateUrlFields="eventId, eventName" DataNavigateUrlFormatString="~/Pages//FindBetTypes.aspx?eventId={0}&eventName={1}" />
            <asp:BoundField DataField="date" meta:resourcekey="colRecommendationDate"/>
            <asp:BoundField DataField="text" meta:resourcekey="colRecommendationDesc" />
        </Columns>
    </asp:GridView>
    </form>
    <br />
    <br />
    <!-- "Previous" and "Next" links. -->
    <div class="previousNextLinks">
        <span class="previousLink">
            <asp:HyperLink ID="lnkPrevious" Text="<%$ Resources:Common, Previous %>" runat="server"
                Visible="False"></asp:HyperLink>
        </span><span class="nextLink">
            <asp:HyperLink ID="lnkNext" Text="<%$ Resources:Common, Next %>" runat="server" Visible="False"></asp:HyperLink>
        </span>
    </div>
</asp:Content>