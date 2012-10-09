<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
CodeBehind="ViewGroups.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.ViewGroups" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <br />
    <p>
        <asp:Label ID="lblNoGroups" meta:resourcekey="lblNoGroups" runat="server"></asp:Label>
    </p>
    <form id="form" runat="server">
    <asp:GridView ID="gvViewGroups" runat="server" CssClass="cooltable" GridLines="None"
        AutoGenerateColumns="False" >
        <Columns>
            <asp:BoundField DataField="name" meta:resourcekey="colGroupName"     />
            <asp:TemplateField meta:resourcekey="colGroupCreator">
                <ItemTemplate>
                    <asp:Label 
                    ID="lblGroupCreator" 
                    runat="server"
                    Text='<%# ((Es.Udc.DotNet.Betbook.Model.User)Eval("user")).login %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="description" meta:resourcekey="colGroupDesc" />
            <asp:HyperLinkField meta:resourcekey="btnJoinGroup" DataNavigateUrlFields="groupId" DataNavigateUrlFormatString="~/Pages/JoinGroup.aspx?groupId={0}" />
        </Columns>
    </asp:GridView>
    </form>
    <br />
    <br />
</asp:Content>